package;

import ds.HList;
using ds.HList.Fn;

class Main {
    public static function main() {
        var h = Cons(42, Cons("hello", Cons(true, Nil)));
        var x = h.first();
        var y = h.rest().first();
        var z = h.get(2.toIndex());
        // var w = h.get(3.toIndex()); // type error
        trace('$x $y $z');
    }
}
