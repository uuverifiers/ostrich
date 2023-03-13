(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1][12]|[0]?[1-9])[\/-]([3][01]|[12]\d|[0]?[1-9])[\/-](\d{4}|\d{2})$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "1") (str.to_re "2"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; toolbarplace\x2Ecom\sUser-Agent\u{3a}\d+\x2Fnewsurfer4\x2Fclient=BysooTBADdcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "toolbarplace.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "/newsurfer4/client=BysooTBADdcww.dmcast.com\u{0a}")))))
; v\x3B\d+more.*is\.htazmnjgmomgbdz\u{2f}zzmw\.gzt
(assert (str.in_re X (re.++ (str.to_re "v;") (re.+ (re.range "0" "9")) (str.to_re "more") (re.* re.allchar) (str.to_re "is.htazmnjgmomgbdz/zzmw.gzt\u{0a}"))))
; ^(97(8|9))?\d{9}(\d|X)$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "97") (re.union (str.to_re "8") (str.to_re "9")))) ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "X")) (str.to_re "\u{0a}")))))
; /\/[a-zA-Z_-]+\.doc$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re ".doc/U\u{0a}")))))
(check-sat)
