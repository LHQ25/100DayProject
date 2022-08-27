package com.example.studydemo.layout;

import android.os.Bundle;

import com.example.studydemo.R;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;

import android.view.View;

import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.example.studydemo.databinding.ActivityRelativeLayoutBinding;

public class RelativeLayoutActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_relative_layout);

        /* 相对布局（RelativeLayout）是一种根据父容器和兄弟控件作为参照来确定控件位置的布局方式 */
    }
}