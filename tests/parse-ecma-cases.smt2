(set-logic QF_S)

(declare-const w String)

(assert (not (and

        (= (str.in_re w (re.from_ecma2020 '[a-z]'))
           (str.in_re w (re.range "a" "z")))

        (= (str.in_re w (re.from_ecma2020 ' *'))
           (str.in_re w (re.* (str.to_re " "))))

        (= (str.in_re w (re.from_ecma2020 '[^A-Za-z]'))
           (str.in_re w (re.inter re.allchar
                          (re.comp
                           (re.union (re.range "a" "z") (re.range "A" "Z"))))))
                           
        (= (str.in_re w (re.from_ecma2020 '\d'))
           (str.in_re w (re.range "0" "9")))
           
        (= (str.in_re w (re.from_ecma2020 '\cg\cG\x07'))
           (= w "\u{7}\u{7}\u{7}"))
           
        (= (str.in_re w (re.from_ecma2020 '(?:\^|\\A)([a-z]*)(?:\$|\\z)'))
           (str.in_re w (re.++ (re.union (str.to_re "^") (str.to_re '\A'))
                               (re.* (re.range "a" "z"))
                               (re.union (str.to_re "$") (str.to_re '\z')))))

        (= (str.in_re w (re.from_ecma2020 '(?=.*[a-z])X.*[A-Z].*'))
           (str.in_re w (re.inter (re.++ (re.from_ecma2020 '.*[a-z]') re.all)
                                  (re.from_ecma2020 'X.*[A-Z].*'))))

        (= (str.in_re w (re.from_ecma2020 '\,'))
           (str.in_re w (str.to.re ",")))

        (= (str.in_re w (re.from_ecma2020_flags '[\u{61}-\u007A0-9]' "u"))
           (str.in_re w (re.union (re.range "a" "z") (re.range "0" "9"))))

        (= (str.in_re w (re.from_ecma2020 '((?=.*?[A-Z])).{8,}'))
           (and (str.in_re w (re.from_ecma2020 '.{8,}'))
                (str.in_re w (re.++ re.all (re.range "A" "Z") re.all))))
           
        (= (str.in_re w (re.from_ecma2020 '()'))
           (str.in_re w (str.to.re "")))

        (= (str.in_re w (re.from_ecma2020 '\b[ ab]*\b'))
           (and (str.in_re w (re.from_ecma2020 '[ ab]+'))
                (not (str.prefixof " " w))
                (not (str.suffixof " " w))))

        (= (str.in_re w (re.from_ecma2020 '\B[ a]*'))
           (and (str.in_re w (re.from_ecma2020 '[ a]*'))
                (not (str.prefixof "a" w))))

        (= (str.in_re w (re.from_ecma2020 '\74abc\076'))
           (str.in_re w (str.to.re "<abc>")))

        (= (str.in_re w (re.from_ecma2020 '[^\0744\76]*'))
           (and (not (str.contains w "<"))
                (not (str.contains w ">"))
                (not (str.contains w "4"))))

        (= (str.in_re w (re.from_ecma2020 '^(?![0-9]*$)[a-z0-9\.]+$'))
           (and (str.in_re w (re.from_ecma2020 '[a-z0-9\.]+'))
                (not (str.in_re w (re.from_ecma2020 '[0-9]*')))))

        (= (str.in_re w (re.from_ecma2020 '^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'))
           (and ; (>= (str.len w) 8)
                (str.in_re w (re.++ ((_ re.^ 8) re.allchar) re.all))
                (str.in_re w (re.++ re.all (re.union (re.range "A" "Z")
                                                     (re.range "a" "z")) re.all))
                (str.in_re w (re.++ re.all (re.range "0" "9") re.all))
                (str.in_re w (re.* (re.union (re.range "A" "Z")
                                             (re.range "a" "z")
                                             (re.range "0" "9"))))))

        ; without the u flag, the \u{...} escape sequence is interpreted literally
        (= (str.in_re w (re.from_ecma2020 '\u{ab}'))
           (= w "u{ab}"))

        (= (str.in_re w (re.from_ecma2020_flags '\p{Uppercase_Letter}' "u"))
           (str.in_re w (re.from_ecma2020_flags '\p{Lu}' "u")))

        (str.in_re "ABC" (re.from_ecma2020_flags '\P{Lowercase_Letter}*' "u"))

        ; without the u flag, the \P{...} property is interpreted literally
        (str.in_re "P{Lowercase_Letter}" (re.from_ecma2020 '\P{Lowercase_Letter}'))

        (str.in_re "a\u{A}b" (re.from_ecma2020_flags '...' "s"))

        (not (str.in_re "a\u{A}b" (re.from_ecma2020_flags '...' "")))

        (= (and (str.in_re w (re.from_ecma2020_flags '\p{l}' "u"))
                (str.in_re w (re.range "\u{00}" "\u{7F}")))
           (str.in_re w (re.from_ecma2020 '[a-zA-Z]')))

        (= (and (str.in_re w (re.from_ecma2020_flags '[\p{l}\p{n}]' "u"))
                (str.in_re w (re.range "\u{00}" "\u{7F}")))
           (str.in_re w (re.from_ecma2020 '[a-zA-Z0-9]')))

        (= (str.in_re w (re.from_ecma2020 '_'))
           (= w "_"))

        (= (str.in_re w (re.from_ecma2020 '[\-0-9a-zA-Z\.\  ]+'))
           (str.in_re w (re.from_ecma2020 '[\-0-9a-zA-Z.  ]+')))

        (= (str.in_re w (re.from_ecma2020 '[0-9\ы═ы║ы╒ыёыєы╔ыіыїы╗ы╘]'))
           (str.in_re w (re.from_ecma2020 '[0-9ы═ы║ы╒ыёыєы╔ыіыїы╗ы╘]')))

        (= (str.in_re w (re.from_ecma2020 '[\-\_\@]'))
           (or (= w "-") (= w "_") (= w "@")))

        (= (str.in_re w (re.from_ecma2020 '\-\d{2}'))
           (str.in_re w (re.from_ecma2020 '-\d{2}')))

 )))

(check-sat)
