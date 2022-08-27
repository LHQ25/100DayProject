package com.example.studydemo.baseui;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.EditText;

import com.example.studydemo.R;

public class EditTextViewTestActivity extends AppCompatActivity {

    private EditText editText;

    /// Activity启动后第一个被调用的函数，常用来进行Activity的初始化，如创建View，绑定数据和恢复数据。
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_text_view_test);

        editText = findViewById(R.id.editView);

        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    /// 当Activity显示在屏幕上时，函数被调用。
    @Override
    protected void onStart() {
        super.onStart();

    }

    /// Activity从停止状态进入活动状态是调用。
    @Override
    protected void onRestart() {
        super.onRestart();
    }

    /// Activity可以接受用户输入时，该函数被调用，此时的activity位于activity栈的栈顶。
    @Override
    protected void onResume() {
        super.onResume();

    }

    /// 当Activity进入暂停状态时，该函数被调用，一般用来保存持久的数据或释放占用的资源。
    @Override
    protected void onPause() {
        super.onPause();
    }

    /// 当Activity变为不可见后，该函数被调用，Activity进入停止状态。
    @Override
    protected void onStop() {
        super.onStop();
    }

    /// 在Activity被终止前，被调用。
    @Override
    protected void onDestroy() {
        super.onDestroy();

    }
}