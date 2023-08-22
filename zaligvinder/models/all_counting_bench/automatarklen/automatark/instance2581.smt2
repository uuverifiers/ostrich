(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (http|ftp|https)://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,4}(/\S*)?$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "http") (str.to_re "ftp") (str.to_re "https")) (str.to_re "://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re "/") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))) (str.to_re "\u{0a}")))))
; ^[1-9]{1}[0-9]{3}\s?[a-zA-Z]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}emf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".emf/i\u{0a}")))))
; \x2Fcs\x2Fpop4\x2FA-Spywww\x2Eyoogee\x2Ecom
(assert (not (str.in_re X (str.to_re "/cs/pop4/A-Spywww.yoogee.com\u{13}\u{0a}"))))
; /^\/\w{1,2}\/\w{1,3}\.class$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".class/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
