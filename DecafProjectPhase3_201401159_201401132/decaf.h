class plus_node : public node {
  protected:
    node *left;
    node *right;

  public:
    plus_node(node *L, node *R): left(L), right(R) {}
};

class times_node : public node {
  protected:
    node *left;
    node *right;

  public:
    times_node(node *L, node *R): left(L), right(R) {}
};