/*
 * Level 2 Order Book Depth and Micro-Price Imbalance Calculator
 *
 * Tracks top of book, bid-ask spread, order book imbalance, and weighted micro-price.
 */

// Initialize empty order book depth tracker
fn new_order_book() {
    return #{
        best_bid: 0.0,
        bid_size: 0.0,
        best_ask: 0.0,
        ask_size: 0.0
    };
}

// Update top of book levels
fn update_l2_quote(book, best_bid, bid_size, best_ask, ask_size) {
    book.best_bid = best_bid * 1.0;
    book.bid_size = bid_size * 1.0;
    book.best_ask = best_ask * 1.0;
    book.ask_size = ask_size * 1.0;
    return book;
}

// Calculate bid-ask spread
fn get_spread(book) {
    return book.best_ask - book.best_bid;
}

// Calculate mid-price
fn get_mid_price(book) {
    return (book.best_bid + book.best_ask) / 2.0;
}

// Calculate volume-weighted micro-price: (bid_size * ask + ask_size * bid) / (bid_size + ask_size)
fn get_micro_price(book) {
    let total_depth = book.bid_size + book.ask_size;
    if total_depth <= 0.0 {
        return get_mid_price(book);
    }
    return (book.bid_size * book.best_ask + book.ask_size * book.best_bid) / total_depth;
}

// Calculate Order Book Imbalance (OBI) in range [-1.0, 1.0]
fn get_order_book_imbalance(book) {
    let total_depth = book.bid_size + book.ask_size;
    if total_depth <= 0.0 {
        return 0.0;
    }
    return (book.bid_size - book.ask_size) / total_depth;
}
