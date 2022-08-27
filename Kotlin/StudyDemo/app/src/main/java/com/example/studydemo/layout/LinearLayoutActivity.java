package com.example.studydemo.layout;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;

import com.example.studydemo.R;

public class LinearLayoutActivity extends AppCompatActivity {

    private LinearLayout linearLayout;

    /*
            线性布局（LinearLayout）主要以水平或垂直方式来排列界面中的控件。
                并将控件排列到一条直线上。
                在线性布局中，如果水平排列，垂直方向上只能放一个控件，
                如果垂直排列，水平方向上也只能方一个控件
             */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_linear_layout);

        linearLayout = (LinearLayout)findViewById(R.id.linearLayoutTest);

        findViewById(R.id.button).setOnClickListener(view -> {
            linearLayout.setOrientation(LinearLayout.VERTICAL);
            linearLayout.setMinimumHeight(140);
        });

        findViewById(R.id.button2).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                linearLayout.setOrientation(LinearLayout.HORIZONTAL);
                linearLayout.setMinimumHeight(30);
            }
        });
    }
}