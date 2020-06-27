package com.seemantshekhar.notify;

public class Helper {
    String fileName;
    public static Helper helper;
    private Helper(){
        fileName = "";
    }

    public  static Helper getInstance(){
        if(helper != null) {
        }
        else{
            helper = new Helper();

        }
        return  helper;
    }
}
