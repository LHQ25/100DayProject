package com.example.listviewdemo;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.example.listviewdemo.adapter.LAdapter;
import com.example.listviewdemo.model.Item;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private ListView listView;
    private SimpleDateFormat simpleDateFormat;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        listView = findViewById(R.id.listview);

        List<Item> items = new ArrayList();
        simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        items.add(new Item(1, "Android ViewPager2 使用 + 自定义指示器视图", simpleDateFormat.format(new Date())));

        LAdapter adapter = new LAdapter(MainActivity.this, R.id.listview, items);

        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener(){
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int postion, long id) {
                if (postion == 0) {

                    Intent intent = new Intent(MainActivity.this, ViewPagerTwo.class);
                    startActivity(intent);
                }
            }
        });
    }
}