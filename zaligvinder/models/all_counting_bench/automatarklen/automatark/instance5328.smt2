(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([4]{1})([0-9]{12,15})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "4")) ((_ re.loop 12 15) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (([2-9]{1})([0-9]{2})([0-9]{3})([0-9]{4}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))
; /\x2Fupdate\w\x2Ephp\x3Fp\x3D\d+.*User\x2DAgent\x3A\s+Mozilla\x2F4\x2E75\s\x5Ben\x5D\s\u{28}X11\x3B\sU\x3B\sLinux\s2\x2E2\x2E16\x2D3\si686\u{29}/smiH
(assert (not (str.in_re X (re.++ (str.to_re "//update") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re ".php?p=") (re.+ (re.range "0" "9")) (re.* re.allchar) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Mozilla/4.75") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "[en]") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "(X11;") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "U;") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Linux") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "2.2.16-3") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "i686)/smiH\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
