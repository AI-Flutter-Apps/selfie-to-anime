package com.example.selfie2anime;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;

import org.pytorch.torchvision.TensorImageUtils;
import org.pytorch.Tensor;


/** Responsible for processing the data before feeding to the model and before returning to the UI*/
public class PrePostProcess {


    /**
     * preProcess function get the image ready for the model
     * @param imgPath
     * @return Tensor
     */
    public static Tensor preProcess(String imgPath){
        // decode image to bitmap
        BitmapFactory.Options options = new BitmapFactory.Options();
        Bitmap _bitmap = BitmapFactory.decodeFile(imgPath);

        // rescale to the models expected size 
        Bitmap rescaledBitmap = resizeBitmap(_bitmap, 128, 128); 

        // convert to tensor and return 
        return TensorImageUtils.bitmapToFloat32Tensor(
            rescaledBitmap, 
            TensorImageUtils.TORCHVISION_NORM_MEAN_RGB, 
            TensorImageUtils.TORCHVISION_NORM_STD_RGB
        );
    }


    /**
     * postProcess function will process the tensor to the expected form in UI
     * @param outputTensor
     * @return Bitmap
     */
    public static Bitmap postProcess(Tensor outputTensor){
        // convert tensor to float[]
        float[] imgArray = outputTensor.getDataAsFloatArray();

        // convert float[] to BitmapRGB
        Bitmap resultBitmap = bitmapFromRGBImageAsFloatArray(imgArray, 128, 128);

        // rotate 90 deg and filp ver. & hor.
        return rotateAndFlipBitMap(resultBitmap, 90);
    }


    /**
     * resizeBitmap function will change the scale of the bitmap
     * @param bitmap
     * @param width
     * @param height
     * @return Bitmap
     */
    public static Bitmap resizeBitmap(Bitmap bitmap, int width, int height){
        return Bitmap.createScaledBitmap(bitmap, width, height, true);
    }


    /**
     * rotateAndFlipBitMap function will rotate 90deg and flip the bitmap
     * @param bitmap
     * @param degree
     * @return bitmap  
     */
    public static Bitmap rotateAndFlipBitMap(Bitmap bitmap, int degree) {
        Matrix matrix = new Matrix();
        matrix.postRotate(degree);
        matrix.postScale(-1,1);

        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
    }

    
    /**
     * bitmapFromRGBImageAsFloatArray function will convert a float array to an RGB bitmap
     * @param data
     * @param width
     * @param height
     * @return bitmap  
     */
    public static Bitmap bitmapFromRGBImageAsFloatArray(float[] data, int width, int height) {
        Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        for (int i = 0; i < width * height; i++) {
            int r = (int) ((data[i] * 0.5 + 0.5) * 255.0f);
            int g = (int) ((data[i + width * height] * 0.5 + 0.5) * 255.0f);
            int b = (int) ((data[i + width * height * 2] * 0.5 + 0.5) * 255.0f);

            int x = i / width;
            int y = i % width;

            int color = Color.rgb(r, g, b);
            bmp.setPixel(x, y, color);
        }
        return bmp;
    }
}
