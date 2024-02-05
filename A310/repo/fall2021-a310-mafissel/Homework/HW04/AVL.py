

class AVL(BST):
    def depth(self): #DEPTH
        if self.left == None and  self.right == None: 
            return 1
        elif self.left ==  None: 
            return 1 + self.right.depth()
        elif self.right == None: 
            return 1 + self.left.depth()
        else:
            return 1 + max(self.left.depth(), self.right.depth())
    
    def balance(self): #BALANCE
        if self.left == None and self.right == None: 
            return 0 
        elif self.left == None: 
            return  0 - self.right.depth()
        elif self.right == None:
            return self.left.depth()  
        else:
            return self.left.depth() - self.right.depth()
        
    def adjust(self): #ADJUST
        if self.left == None:  
            dl, left = 0,  None
        else:
            left = self.left.adjust()
            dl = left.depth()
        if self.right == None:
            dr, right =  0, None
        else:
            right = self.right.adjust()
            dr = right.depth()
        if dl - dr == -2: #HEAVY RIGHT
            if right.balance() > 0: #RIGHT SUBTREE HEAVY LEFT
                return AVL(right.left.key, AVL(self.key,left,right.left.left), AVL(right.key,right.left.right, right.right))
            else: 
                return AVL(right.key, AVL(self.key,left,right.left), AVL(right.right.key, right.right.left, right.right.right))
        elif dl - dr == 2: # HEAVY LEFT
            if left.balance() < 0: #LEFT SUBTREE HEAVY RIGHT
                return AVL(left.right.key, AVL(left.key, left.left, left.right.left), AVL(self.key, left.right, right))
            else: 
                return AVL(left.key, AVL(left.left.key, left.left.left, left.left.right), AVL(self.key, left.right, right))
        return AVL(self.key, left, right)