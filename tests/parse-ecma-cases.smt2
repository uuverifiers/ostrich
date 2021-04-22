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

        (= (str.in_re w (re.from_ecma2020 '[\u{61}-\u007A0-9]'))
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

 )))

(check-sat)
