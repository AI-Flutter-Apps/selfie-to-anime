package com.example.selfie2anime;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.os.StrictMode;
import java.io.IOException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

import org.pytorch.Tensor;

import com.example.selfie2anime.Model;
import com.example.selfie2anime.PrePostProcess;
import com.example.selfie2anime.FileManagment;


/** MainActivity acts as the controller */
public class MainActivity extends FlutterActivity {
    private static final String channel = "selfie.anime";
    private Model model;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), channel).setMethodCallHandler(
                (call, result) -> {
                    if (call.method != null) {
                        result.success(anime((String) call.arguments));
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    private String anime(String imgpath) {
        String filepath = FileManagment.getFilePath(imgpath);

        // load model 
        try { model = new Model(FileManagment.assetFilePath(this, "opt2.pt"));}
        catch(IOException e){
            Log.e("anime", "error reading assets", e);
            return imgpath;
        }

        // preprocess 
        Tensor inputTensor = PrePostProcess.preProcess(imgpath);

        // feedforward
        Tensor outputTensor = model.feedForward(inputTensor);

        // postprocess
        Bitmap resultBitmap = PrePostProcess.postProcess(outputTensor);

        // save and return
        FileManagment.saveBitmap(resultBitmap, filepath + "/result.png");
        return filepath + "/result.png";
    }
}