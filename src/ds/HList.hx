/*

Copyright (c) 2015 Ryusei Yamaguchi <mandel59@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package ds;

class TList {}
class TCons<X,L:TList> extends TList {}
class TNil extends TList {}

enum HList<L:TList> {
    Nil: HList<TNil>;
    Cons<X,L:TList>(x: X, l: HList<L>): HList<TCons<X,L>>;
}

enum Index<L:TList,Y> {
    Here<X,L:TList>: Index<TCons<X,L>,X>;
    There<X,L:TList,Y>(i: Index<L,Y>): Index<TCons<X,L>,Y>;
}

class Fn {
    public static inline function unwrap<X>(h: HList<TCons<X,TNil>>): X {
        return first(h);
    }

    public static inline function first<X,L:TList>(h: HList<TCons<X,L>>): X {
        return switch(h) {
            case Cons(x, _): x;
        }
    }

    public static inline function rest<X,L:TList>(h: HList<TCons<X,L>>): HList<L> {
        return switch(h) {
            case Cons(_, l): l;
        }
    }

    public static function get<L:TList,Y>(h: HList<L>, i: Index<L,Y>): Y {
        return switch(i) {
            case Here:
                first(h);
            case There(i):
                get(rest(h), i);
        }
    }

    public static macro function toIndex(n: Int) {
        if(n < 0) {
            throw "HList: should be positive index";
        }
        return buildIndex(n);
    }

    static function buildIndex(n: Int) {
        if(n == 0) {
            return macro ds.HList.Index.Here;
        }
        var i = buildIndex(n - 1);
        return macro ds.HList.Index.There($e{i});
    }
}
