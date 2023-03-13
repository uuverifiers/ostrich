(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-1])*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "1")) (str.to_re "\u{0a}")))))
; ^(b|B)(f|F)(p|P)(o|O)(\s|\sC/O\s)[0-9]{1,4}
(assert (not (str.in_re X (re.++ (re.union (str.to_re "b") (str.to_re "B")) (re.union (str.to_re "f") (str.to_re "F")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "o") (str.to_re "O")) ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re "\u{0a}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "C/O") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
; zmnjgmomgbdz\u{2f}zzmw\.gzt.*www\x2Ealtnet\x2Ecom.*User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "zmnjgmomgbdz/zzmw.gzt") (re.* re.allchar) (str.to_re "www.altnet.com\u{1b}") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}"))))
; downloads\x2Emorpheus\x2Ecom\x2Frotation
(assert (not (str.in_re X (str.to_re "downloads.morpheus.com/rotation\u{0a}"))))
(check-sat)
