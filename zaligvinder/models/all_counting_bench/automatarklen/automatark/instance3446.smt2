(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.php\?hgfc\=[a-f0-9]+$/U
(assert (str.in_re X (re.++ (str.to_re "/.php?hgfc=") (re.+ (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; ^[0-9]%?$|^1[0-9]%?$|^2[0-9]%?$|^3[0-5]%?$|^[0-9]\.\d{1,2}%?$|^1[0-9]\.\d{1,2}%?$|^2[0-9]\.\d{1,2}%?$|^3[0-4]\.\d{1,2}%?$|^35%?$
(assert (str.in_re X (re.union (re.++ (re.range "0" "9") (re.opt (str.to_re "%"))) (re.++ (str.to_re "1") (re.range "0" "9") (re.opt (str.to_re "%"))) (re.++ (str.to_re "2") (re.range "0" "9") (re.opt (str.to_re "%"))) (re.++ (str.to_re "3") (re.range "0" "5") (re.opt (str.to_re "%"))) (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (str.to_re "%"))) (re.++ (str.to_re "1") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (str.to_re "%"))) (re.++ (str.to_re "2") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (str.to_re "%"))) (re.++ (str.to_re "3") (re.range "0" "4") (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (str.to_re "%"))) (re.++ (str.to_re "35") (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; /\u{2e}p2g([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.p2g") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
