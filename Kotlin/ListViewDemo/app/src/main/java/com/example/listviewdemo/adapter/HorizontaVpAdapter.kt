package com.example.listviewdemo.adapter

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.listviewdemo.R

class HorizontalVpAdapter(val mContext: Context): RecyclerView.Adapter<HorizontalVpAdapter.HorizontalVpViewHolder>() {

    private var backgrounds: ArrayList<Int> = ArrayList()

    init {
        backgrounds.add(R.color.h_red)
        backgrounds.add(R.color.h_green)
        backgrounds.add(R.color.h_blue)
    }

    override fun getItemCount(): Int {
        return backgrounds.size
    }

    class HorizontalVpViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var backgroundView: RelativeLayout
        var textView: TextView

        init {
            backgroundView = itemView.findViewById(R.id.item_view_layout)
            textView = itemView.findViewById(R.id.rec_textview)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): HorizontalVpViewHolder {
        return HorizontalVpViewHolder(LayoutInflater.from(mContext).inflate(R.layout.itemview, parent, false))
    }

    override fun onBindViewHolder(holder: HorizontalVpViewHolder, position: Int) {
        holder.backgroundView.setBackgroundResource(backgrounds[position])
        holder.textView.text = "第 $position View"
    }
}