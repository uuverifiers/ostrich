(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3})$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}gz/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".gz/i\u{0a}"))))
; ^([\#]{0,1}([a-fA-F0-9]{6}|[a-fA-F0-9]{3})|rgb\(([0-9]{1},|[1-9]{1}[0-9]{1},|[1]{1}[0-9]{2},|[2]{1}[0-4]{1}[0-9]{1},|25[0-5]{1},){2}([0-9]{1}|[1-9]{1}[0-9]{1}|[1]{1}[0-9]{2}|[2]{1}[0-4]{1}[0-9]{1}|25[0-5]{1}){1}\)|rgb\(([0-9]{1}%,|[1-9]{1}[0-9]{1}%,|100%,){2}([0-9]{1}%|[1-9]{1}[0-9]{1}%|100%){1}\))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "#")) (re.union ((_ re.loop 6 6) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) ((_ re.loop 3 3) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))))) (re.++ (str.to_re "rgb(") ((_ re.loop 2 2) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",")) (re.++ ((_ re.loop 1 1) (str.to_re "1")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ",")) (re.++ ((_ re.loop 1 1) (str.to_re "2")) ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",")) (re.++ (str.to_re "25") ((_ re.loop 1 1) (re.range "0" "5")) (str.to_re ",")))) ((_ re.loop 1 1) (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "1")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "2")) ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "25") ((_ re.loop 1 1) (re.range "0" "5"))))) (str.to_re ")")) (re.++ (str.to_re "rgb(") ((_ re.loop 2 2) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "%,")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "%,")) (str.to_re "100%,"))) ((_ re.loop 1 1) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "%")) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "%")) (str.to_re "100%"))) (str.to_re ")"))) (str.to_re "\u{0a}")))))
; /\u{2e}xbm([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.xbm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; \w*
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
