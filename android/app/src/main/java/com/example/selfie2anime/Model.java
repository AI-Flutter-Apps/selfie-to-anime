package com.example.selfie2anime;

import org.pytorch.Module;
import org.pytorch.IValue;
import org.pytorch.LiteModuleLoader;
import org.pytorch.Tensor;


/** Responsible for loading the model and feedforward */
public class Model {
    private Module model;

    Model(String modelPath) {
        this.model = load(modelPath);
    }

    /** 
     * load function will load the model
     * @param modelPath
     * @return Module
     */
    public Module load(String modelPath){
        return LiteModuleLoader.load(modelPath);
    }


    /**
     * feedForward function will feed the data into the model
     * @param inputTensor
     * @return Tensor
     */
    public Tensor feedForward(Tensor inputTensor){
        return this.model.forward(IValue.from(inputTensor)).toTensor();
    }
}
