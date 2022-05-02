//
//  main.cpp
//  DS_最优解
//
//  Created by 娄汉清 on 2022/3/5.
//

#include <iostream>

template <typename T>
class TreeNode {
    
public:
    T data;
    TreeNode<T> *lefeChild;
    TreeNode<T> *rightChild;
    
public:
    
    TreeNode(){
        this->data = -1;
        this->lefeChild = NULL;
        this->rightChild = NULL;
    }
    
    TreeNode(T data): data(data) {
        this->lefeChild = nullptr;
        this->rightChild = nullptr;
    }
    TreeNode(T data, TreeNode<T> *l, TreeNode<T> *r): data(data), lefeChild(l), rightChild(r) {}
    
    bool operator==(const TreeNode &A);
};

template<typename T>
bool TreeNode<T>::operator==(const TreeNode<T> &o) {
    
    return this->data == o.data && this->lefeChild==o.lefeChild && this->rightChild==o.rightChild;
}


template <typename T>
void printTree(TreeNode<T> *tree) {
    
    if (tree != NULL) {
        
        if (tree->lefeChild != NULL) {
            printTree(tree->lefeChild);
        }
        if (tree->data != -1) {
            printf("%d",tree->data);
        }
        if (tree->rightChild != NULL) {
            printTree(tree->rightChild);
        }
    }
}

template <typename T>
void addTreeNode(TreeNode<T> *tree, T val) {
    
    if (val == -1) {
        return;
    }
    
    T n_val = val;
    
    if (val > tree->data) {
        n_val = tree->data;
        tree->data = val;
    }

    if (n_val == -1) {
        return;
    }
//    {7,9,2,4,1,5,8,6};
    TreeNode<T> *left = tree->lefeChild;
    TreeNode<T> *right = tree->rightChild;
    
    if (left == nullptr) {
        
        tree->lefeChild = new TreeNode<T>(n_val);
        return;
    }else if (n_val > left->data) {
        
        T n = left->data;
        left->data = n_val;
        
//        addTreeNode(right, n);
        n_val = n;
//        return;
    }
//    else {
        if (right == nullptr) {
            tree->rightChild = new TreeNode<T>(n_val);;
            return;
        }else if (n_val > right->data) {
            T n = right->data;
            right->data = n_val;
            addTreeNode(left, n);
//            n_val = n;
        }else{
            if (left->lefeChild->data < n_val && left->rightChild->data < n_val) {
                addTreeNode(right, n_val);
            }else {
                addTreeNode(left, n_val);
            }
        }
    
//        if (n_val != -1 ) {
//            tree->lefeChild->lefeChild = new TreeNode<T>(n_val);
//        }
        
//    }
//    if (n_val > right->data) {
//        n_val = right->data;
//        addTreeNode(*right, n_val);
//    }
}

int main(int argc, const char * argv[]) {
    
    std::cout << "Hello, World!\n";
    
    int a[] = {7,9,2,4,1,5,8,6};
    
    TreeNode<int> t = TreeNode<int>(a[0]); //7
    
    for (int i=1; i<8; i++) {
        printf("%d", a[i]);
        addTreeNode(&t, a[i]);
    }
    printf("\n");
    printTree(&t);
    
//                9
//          8           7
//      6       5  4       2
//    1
    // 1 6 8 5 9 4 7 2
    
    return 0;
}
