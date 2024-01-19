(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; for mobile:^[0][1-9]{1}[0-9]{9}$
(assert (not (str.in_re X (re.++ (str.to_re "for mobile:0") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(0|(\+)?([1-9]{1}[0-9]{0,3})|([1-5]{1}[0-9]{1,4}|[6]{1}([0-4]{1}[0-9]{3}|[5]{1}([0-4]{1}[0-9]{2}|[5]{1}([0-2]{1}[0-9]{1}|[3]{1}[0-5]{1})))))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "5")) ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "6")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "3")) ((_ re.loop 1 1) (re.range "0" "5")))))))))) (str.to_re "\u{0a}")))))
; (0?[1-9]|[1-9][0-9])[0-9]{6}(-| )?[trwagmyfpdxbnjzsqvhlcke]
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))) ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.union (str.to_re "t") (str.to_re "r") (str.to_re "w") (str.to_re "a") (str.to_re "g") (str.to_re "m") (str.to_re "y") (str.to_re "f") (str.to_re "p") (str.to_re "d") (str.to_re "x") (str.to_re "b") (str.to_re "n") (str.to_re "j") (str.to_re "z") (str.to_re "s") (str.to_re "q") (str.to_re "v") (str.to_re "h") (str.to_re "l") (str.to_re "c") (str.to_re "k") (str.to_re "e")) (str.to_re "\u{0a}")))))
; /\x2Ermf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.rmf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
