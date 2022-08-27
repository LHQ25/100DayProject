package com.example.studydemo.ui;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import com.example.studydemo.R;

public class AlertDialogActivity extends AppCompatActivity {

    private AlertDialog alert;
    private AlertDialog.Builder builder;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_alert_dialog);

        findViewById(R.id.button3).setOnClickListener(v -> {
            // 创建对象
            builder = new AlertDialog.Builder(AlertDialogActivity.this)
                    .setTitle("普通对话框")
                    .setIcon(R.mipmap.ic_launcher)
                    .setMessage("普通对话框，三三个按钮")
                    .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {

                        }
                    })
                    .setNegativeButton("取消", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {

                        }
                    })
                    .setNeutralButton("中立", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {

                        }
                    });
            alert = builder.create();
            alert.show();
        });

        String[] lesson = new String[]{"语文", "数学", "音乐", "化学"};
        findViewById(R.id.button4).setOnClickListener(v -> {
            // 创建对象
            builder = new AlertDialog.Builder(AlertDialogActivity.this)
                    .setTitle("普通列表对话框")
                    .setIcon(R.mipmap.ic_launcher)
                    .setItems(lesson, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            Toast.makeText(AlertDialogActivity.this, lesson[which], Toast.LENGTH_SHORT).show();
                        }
                    })
                    .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {

                        }
                    });
            alert = builder.create();
            alert.show();
        });

        findViewById(R.id.button5).setOnClickListener(v -> {
            // 创建对象
            builder = new AlertDialog.Builder(AlertDialogActivity.this)
                    .setTitle("单选对话框")
                    .setIcon(R.mipmap.ic_launcher)
                    .setSingleChoiceItems(lesson, 0, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            Toast.makeText(AlertDialogActivity.this, lesson[which], Toast.LENGTH_SHORT).show();
                        }
                    });
            alert = builder.create();
            alert.show();
        });

        CharSequence[] charSequence = new CharSequence[]{"篮球", "足球", "羽毛球", "网球"};
        boolean[] checkItems = new boolean[]{false, false, false, false};
        findViewById(R.id.button6).setOnClickListener(v -> {
            // 创建对象
            builder = new AlertDialog.Builder(AlertDialogActivity.this)
                    .setTitle("单选对话框")
                    .setIcon(R.mipmap.ic_launcher)
                    .setMultiChoiceItems(charSequence, checkItems, new DialogInterface.OnMultiChoiceClickListener(){

                        @Override
                        public void onClick(DialogInterface dialog, int which, boolean isChecked) {

                        }
                    })
                    .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {

                        }
                    });
            alert = builder.create();
            alert.show();
        });

        findViewById(R.id.button7).setOnClickListener(v -> {
            // 创建对象
            builder = new AlertDialog.Builder(AlertDialogActivity.this);
            final LayoutInflater inflater = AlertDialogActivity.this.getLayoutInflater();
            View view_custom = inflater.inflate(R.layout.view_dialog_custom, null, false);
            builder.setView(view_custom);
            builder.setCancelable(false);
            alert = builder.create();
            view_custom.findViewById(R.id.btn_cancel).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    alert.dismiss();
                }
            });
            alert.show();
        });
    }
}