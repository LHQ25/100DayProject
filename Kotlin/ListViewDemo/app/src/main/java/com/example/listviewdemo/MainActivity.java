package com.example.listviewdemo;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Context;
import android.media.Image;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;
import java.util.zip.Inflater;

public class MainActivity extends AppCompatActivity {

    private ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        listView = findViewById(R.id.listview);

        List<Item> items = new ArrayList();
        items.add(new Item(1, "12312"));

        MyAdapter adapter = new MyAdapter(MainActivity.this, R.id.listview, items);

        listView.setAdapter(adapter);
    }
}

class MyAdapter extends ArrayAdapter<Item> {

    private final List<Item> items;

    public MyAdapter(Context context, int resource, List<Item> objects) {
        super(context, resource, objects);

        items = objects;
    }

    @Override
    public int getCount() {
        return items.size();
    }

    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        View view;
        ViewHolder viewHolder;
        if (convertView == null) {
            view = LayoutInflater.from(getContext()).inflate(R.layout.item, parent, false);
            ImageView image = view.findViewById(R.id.imageview);
            TextView t = view.findViewById(R.id.txt);
            viewHolder = new ViewHolder();
            viewHolder.imageView = image;
            viewHolder.name = t;
            view.setTag(viewHolder);
        }else {
            view = convertView;
            viewHolder = (ViewHolder) convertView.getTag();
        }
        viewHolder.imageView.setImageResource(R.drawable.ic_launcher_background);
        viewHolder.name.setText(items.get(position).getName());
        return view;
    }

    class ViewHolder {
        ImageView imageView;
        TextView name;
    }
}

class Item {

    int id;
    String name;

    public Item(int id, String name){
        this.id = id;
        this.name = name;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}