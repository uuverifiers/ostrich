(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Epurityscan\x2Ecom.*
(assert (not (str.in_re X (re.++ (str.to_re "www.purityscan.com") (re.* re.allchar) (str.to_re "\u{0a}")))))
; Server.*Host\u{3a}\s+newsSoftActivitypassword\x3B1\x3BOptix
(assert (str.in_re X (re.++ (str.to_re "Server") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "newsSoftActivity\u{13}password;1;Optix\u{0a}"))))
; Host\x3A\ssource%3Dultrasearch136%26campaign%3Dsnap
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "source%3Dultrasearch136%26campaign%3Dsnap\u{0a}"))))
; Stablecmemailyxegtd\u{2f}efcwgUin=PromulGate
(assert (not (str.in_re X (str.to_re "Stablecmemailyxegtd/efcwgUin=PromulGate\u{0a}"))))
; ^(([0]?[1-9])|(1[0-2]))\/(([0]?[1-9])|([1,2]\d{1})|([3][0,1]))\/[12]\d{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "1")))) (str.to_re "/") (re.union (str.to_re "1") (str.to_re "2")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
