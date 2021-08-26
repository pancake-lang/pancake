# 🥞 Pancake Programming Language

Pancake is an esoteric programming language that is conceptually split into two
worlds -- _alpha_ and _omega_. But don't worry, those are two sides of the same
pancake 😉.

This project was concieved during the first [Lang Jam][langjam] with an amazing
team of creative coders:

- [Aleksi the `aleksimart`](https://github.com/aleksimart)
- [Holly the `dejawuuu`](https://github.com/dejawuuu)
- [Kyle the `Kylebrown9`](https://github.com/Kylebrown9)
- [Viktor the `sharpvik`](https://github.com/sharpvik)

**NOTE:** [this site][playground] is an IDE for our language. Take a look at
the **Editor** section to learn more!

[playground]: https://pancake-lang.github.io/pancake
[langjam]: https://github.com/langjam/jam0001

## Internals

Internally, Pancake runtime is a very simple stack machine that keeps track of
the current world in which it's operating. Commands are executed top to bottom
(although there are jumps) and if we are in the _alpha_ world, all _omega_
instructions are skipped (and vice versa).

> You can `flip`, `flip if true`, or `flip if false` between the worlds to
> create conditional statements. That is what makes Pancake so special and
> yummy!

## Syntax and Semantics

Here's an example of a simple program with world and stack state annotated for
the first pass:

```
3               ; ALPHA [ 3 ]
{i}             ; ALPHA [ 3 {i} ]
bind            ; ALPHA [ ]                  { i = 3 }
i               ; ALPHA [ i ]                { i = 3 }

@ loop start

flip if false   ; ALPHA [ ]                  { i = 3 }
# loop end      ; skipped

"hello world"   ; ALPHA [ "hello world" ]    { i = 3 }
print           ; ALPHA [ ]                  { i = 3 }

i               ; ALPHA [ 3 ]                { i = 3 }
1               ; ALPHA [ 3 1 ]              { i = 3 }
-               ; ALPHA [ 2 ]                { i = 3 }
{i}             ; ALPHA [ 2 {i} ]            { i = 3 }
bind            ; ALPHA [ ]                  { i = 2 }

loop start

@ loop end      ; "loop end" is a label to which we can jump
```

This program will print `hello world` three times before halting forever. Here's
what we can learn from looking at it:

1. Each line is an instruction.
2. Lines prefixed with `@` are lables to which we can jump by writing their name
   on one of the lines.
3. Instructions in the _alpha_ world are not prefixed, while _omega_
   instructions have a leading `#`.
4. Names like `i` can be put on the stack raw, without being evaluated if you
   wrap them in `{ }`. This can be used to `bind` a variable or in higher order
   functions.
5. All names and their values are stored in a global namespace.

## Editor

### Key Bindings

- `CTRL + ;` = toggle help
- `CTRL + ENTER` = run source code checks
