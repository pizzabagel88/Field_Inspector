package com.example.field_inspector

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Matrix
import android.graphics.Paint
import android.graphics.Typeface
import android.media.ExifInterface
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.field_inspector/gallery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveToGallery") {
                val imagePath = call.argument<String>("imagePath")
                val annotations = call.argument<List<Map<String, Any>>>("annotations")
                if (imagePath != null) {
                    val savedPath = saveImageToGallery(imagePath, annotations)
                    if (savedPath != null) {
                        result.success(savedPath)
                    } else {
                        result.error("SAVE_ERROR", "Failed to save image to gallery", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Image path is null", null)
                }
            } else if (call.method == "openGallery") {
                openGalleryApp()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun saveImageToGallery(imagePath: String, annotations: List<Map<String, Any>>?): String? {
        return try {
            val context = applicationContext
            val contentResolver = context.contentResolver
            
            val imageFile = File(imagePath)
            if (!imageFile.exists()) {
                return null
            }

            // Load the image with proper orientation handling
            val bitmap = BitmapFactory.decodeFile(imagePath)
            val orientedBitmap = fixBitmapOrientation(imagePath, bitmap)
            
            // Add annotations if provided
            val annotatedBitmap = if (annotations != null && annotations.isNotEmpty()) {
                addAnnotationsToBitmap(orientedBitmap, annotations)
            } else {
                orientedBitmap
            }

            // Save to temporary file
            val tempFile = File(context.cacheDir, "temp_annotated_${System.currentTimeMillis()}.jpg")
            val fos = FileOutputStream(tempFile)
            annotatedBitmap.compress(Bitmap.CompressFormat.JPEG, 95, fos)
            fos.flush()
            fos.close()

            // Use MediaStore to save to gallery
            val contentValues = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, "field_inspector_${System.currentTimeMillis()}.jpg")
                put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES + "/Field Inspector")
                put(MediaStore.Images.Media.IS_PENDING, 1)
            }

            val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
            
            if (uri != null) {
                contentResolver.openOutputStream(uri).use { outputStream ->
                    tempFile.inputStream().use { inputStream ->
                        inputStream.copyTo(outputStream!!)
                    }
                }
                
                contentValues.clear()
                contentValues.put(MediaStore.Images.Media.IS_PENDING, 0)
                contentResolver.update(uri, contentValues, null, null)
                
                // Clean up temp file
                tempFile.delete()
                
                return uri.toString()
            }
            
            null
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun fixBitmapOrientation(imagePath: String, bitmap: Bitmap): Bitmap {
        return try {
            val exif = ExifInterface(imagePath)
            val orientation = exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION,
                ExifInterface.ORIENTATION_NORMAL
            )

            val matrix = Matrix()
            when (orientation) {
                ExifInterface.ORIENTATION_ROTATE_90 -> matrix.postRotate(90f)
                ExifInterface.ORIENTATION_ROTATE_180 -> matrix.postRotate(180f)
                ExifInterface.ORIENTATION_ROTATE_270 -> matrix.postRotate(270f)
                ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> {
                    matrix.postScale(-1f, 1f)
                }
                ExifInterface.ORIENTATION_FLIP_VERTICAL -> {
                    matrix.postScale(1f, -1f)
                }
                ExifInterface.ORIENTATION_TRANSPOSE -> {
                    matrix.postRotate(270f)
                    matrix.postScale(-1f, 1f)
                }
                ExifInterface.ORIENTATION_TRANSVERSE -> {
                    matrix.postRotate(90f)
                    matrix.postScale(-1f, 1f)
                }
                else -> return bitmap
            }

            val rotatedBitmap = Bitmap.createBitmap(
                bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true
            )
            
            // Recycle the original bitmap if we created a new one
            if (rotatedBitmap != bitmap) {
                bitmap.recycle()
            }
            
            rotatedBitmap
        } catch (e: Exception) {
            e.printStackTrace()
            bitmap
        }
    }

    private fun addAnnotationsToBitmap(bitmap: Bitmap, annotations: List<Map<String, Any>>): Bitmap {
        val mutableBitmap = bitmap.copy(Bitmap.Config.ARGB_8888, true)
        val canvas = Canvas(mutableBitmap)
        
        val paint = Paint().apply {
            color = Color.WHITE
            textSize = mutableBitmap.width * 0.025f // Scale text size with image
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.NORMAL)
            isAntiAlias = true
        }

        val imageWidth = mutableBitmap.width.toFloat()
        val imageHeight = mutableBitmap.height.toFloat()
        val bottomMargin = imageHeight * 0.08f
        val leftMargin = imageWidth * 0.025f
        val rightMargin = imageWidth * 0.025f
        val lineHeight = paint.textSize * 1.5f

        // Draw left annotations
        var yPosition = imageHeight - bottomMargin
        for (annotation in annotations) {
            val placement = annotation["placement"] as? String
            val text = annotation["text"] as? String ?: ""
            
            if (placement == "left") {
                canvas.drawText(text, leftMargin, yPosition, paint)
                yPosition -= lineHeight
            }
        }

        // Draw right annotations
        yPosition = imageHeight - bottomMargin
        for (annotation in annotations) {
            val placement = annotation["placement"] as? String
            val text = annotation["text"] as? String ?: ""
            
            if (placement == "right") {
                val textWidth = paint.measureText(text)
                canvas.drawText(text, imageWidth - rightMargin - textWidth, yPosition, paint)
                yPosition -= lineHeight
            }
        }

        return mutableBitmap
    }

    private fun openGalleryApp() {
        try {
            val intent = Intent(Intent.ACTION_VIEW).apply {
                type = "image/*"
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
