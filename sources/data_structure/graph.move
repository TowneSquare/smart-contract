/*
    social graph module.
    
    A bi-directed Edges graph of users and their relationships 
    build based on sparse matrix;
    - User: Vertex/Node
    - Relationship: Edge
    
    Smart table consists of:
    - key: user address
    - value: smart vector of addresses following user address
    TODO:
        - Init module
*/

module townesquare::graph {
    use aptos_std::smart_table::{SmartTable};
    use aptos_std::smart_vector::{SmartVector};

    // storage for node; storing only the address
    struct Node<T> has drop, store {
        inner: address
    }

    // storage for edge; list of addresses; R: relationship type
    struct Edge<R> has drop, store {
        
    }

    struct Graph<T, R> {
        table: SmartTable<Node<T>, Edge<R>>,
    }
}