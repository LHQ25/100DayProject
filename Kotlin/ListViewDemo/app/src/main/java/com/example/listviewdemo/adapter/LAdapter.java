package com.example.listviewdemo.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.listviewdemo.R;
import com.example.listviewdemo.model.Item;

import java.util.List;

public class LAdapter extends ArrayAdapter<Item> {

    private final List<Item> items;

    public LAdapter(Context context, int resource, List<Item> objects) {
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
        LAdapter.ViewHolder viewHolder;
        if (convertView == null) {
            view = LayoutInflater.from(getContext()).inflate(R.layout.item, parent, false);
            ImageView image = view.findViewById(R.id.imageview);
            TextView t = view.findViewById(R.id.txt);
            TextView time = view.findViewById(R.id.create_time);
            viewHolder = new LAdapter.ViewHolder();
            viewHolder.imageView = image;
            viewHolder.name = t;
            viewHolder.time = time;
            view.setTag(viewHolder);
        } else {
            view = convertView;
            viewHolder = (LAdapter.ViewHolder) convertView.getTag();
        }
        viewHolder.imageView.setImageResource(R.drawable.ic_launcher_background);
        viewHolder.name.setText(items.get(position).getName());
        viewHolder.time.setText(items.get(position).getTime());
        return view;
    }


    class ViewHolder {
        ImageView imageView;
        TextView name;
        TextView time;
    }
}
