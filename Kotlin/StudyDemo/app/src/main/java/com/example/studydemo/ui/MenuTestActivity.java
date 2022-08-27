package com.example.studydemo.ui;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.os.Bundle;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.example.studydemo.R;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MenuTestActivity extends AppCompatActivity {

    private TextView tx;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu_test);

        tx = findViewById(R.id.textView2);
        tx.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                Toast.makeText(MenuTestActivity.this, "1", Toast.LENGTH_SHORT).show();
            }
        });

        //1. 注册上context menu
        registerForContextMenu(tx);

        // 子菜单（SubMenu）
        //子菜单就是在<item>中又嵌套了一层<menu>，也可以再嵌套一层
    }

    //MARK: - Options Menu
    @Override  // 创建menu
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_optionmenu, menu);
        return true;
    }

    @Override
    public boolean onMenuOpened(int featureId, Menu menu) {
        if (menu != null) {
            if (menu.getClass().getSimpleName().equalsIgnoreCase("MenuBuilder")) {

                try {
                    Method method = menu.getClass().getDeclaredMethod("setOptionalIconsVisible", Boolean.TYPE);
                    method.setAccessible(true);
                    method.invoke(menu, true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return super.onMenuOpened(featureId, menu);
    }

    @Override  // menu的点击事件
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {

        tx.setText(item.getTitle());

        switch (item.getItemId()) {
            case R.id.menu1:
                Toast.makeText(this, "1", Toast.LENGTH_SHORT).show();
            case R.id.menu2:
                Toast.makeText(this, "2", Toast.LENGTH_SHORT).show();
            case R.id.menu3:
                Toast.makeText(this, "2", Toast.LENGTH_SHORT).show();
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onOptionsMenuClosed(Menu menu) {
        super.onOptionsMenuClosed(menu);

        Toast.makeText(this, "menu close", Toast.LENGTH_SHORT).show();
    }

    //MARK: - Context Menu  长按执行
    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
        super.onCreateContextMenu(menu, v, menuInfo);
        MenuInflater menuInflater = new MenuInflater(this);
        menuInflater.inflate(R.menu.ment_context, menu);
        //super.onCreateContextMenu(menu, v, menuInfo);
    }

    @Override
    public boolean onContextItemSelected(@NonNull MenuItem item) {
        tx.setText(item.getTitle());

        switch (item.getItemId()) {
            case R.id.contextm1:
                Toast.makeText(this, "contextm1", Toast.LENGTH_SHORT).show();
            case R.id.contextm2:
                Toast.makeText(this, "contextm2", Toast.LENGTH_SHORT).show();
            case R.id.contextm3:
                Toast.makeText(this, "contextm3", Toast.LENGTH_SHORT).show();
        }
        return super.onContextItemSelected(item);
    }

    @Override
    public void onContextMenuClosed(@NonNull Menu menu) {
        Toast.makeText(this, "context menu close", Toast.LENGTH_SHORT).show();
    }
}