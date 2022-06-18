package com.example.selfie2anime;

import android.content.Context;
import android.graphics.Bitmap;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


/** Responsible for getting assets and saving files */
public class FileManagment {


    /**
     * assetFilePath returns the asset absolute path
     * @param context
     * @param assetName
     * @return
     * @throws IOException
     */
    public static String assetFilePath(Context context, String assetName) throws IOException {
        File file = new File(context.getFilesDir(), assetName);
        if (file.exists() && file.length() > 0) {
          return file.getAbsolutePath();
        }
       
        try (InputStream is = context.getAssets().open(assetName)) {
          try (OutputStream os = new FileOutputStream(file)) {
            byte[] buffer = new byte[4 * 1024];
            int read;
            while ((read = is.read(buffer)) != -1) {
              os.write(buffer, 0, read);
            }
            os.flush();
          }
          return file.getAbsolutePath();
        }
    }


    /**
     * getFilePath returns the path where the image is stored
     * @param filename
     * @return String
     */
    public static String getFilePath(String filename) {
        String filepath = "";
        String[] tmp = filename.trim().split("/");
        
        for (int i = 1; i < tmp.length - 1; i++) {
            filepath += "/" + tmp[i];
        }
        return tmp[0] + filepath;
    }
    

    /**
     * saveBitmap will save the result in the same path it was previously in
     * @param bitmap
     * @param savePath
     */
    public static void saveBitmap(Bitmap bitmap,String savePath){
        File f = new File(savePath);
        if (f.exists()){
            f.delete();
        }
        try{
            FileOutputStream out = new FileOutputStream(f);
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out);
            out.flush();
            out.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
