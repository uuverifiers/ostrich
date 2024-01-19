(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /([etDZhns8dz]{1,3}k){3}[etDZhns8dz]{1,3}f[etDZhns8dz]{16}A/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 3 3) (re.++ ((_ re.loop 1 3) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "k"))) ((_ re.loop 1 3) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "f") ((_ re.loop 16 16) (re.union (str.to_re "e") (str.to_re "t") (str.to_re "D") (str.to_re "Z") (str.to_re "h") (str.to_re "n") (str.to_re "s") (str.to_re "8") (str.to_re "d") (str.to_re "z"))) (str.to_re "A/\u{0a}"))))
; ^((0*[0-1]?[0-9]{1,2}\.)|(0*((2[0-4][0-9])|(25[0-5]))\.)){3}((0*[0-1]?[0-9]{1,2})|(0*((2[0-4][0-9])|(25[0-5]))))$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.++ (re.* (str.to_re "0")) (re.opt (re.range "0" "1")) ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".")) (re.++ (re.* (str.to_re "0")) (re.union (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ".")))) (re.union (re.++ (re.* (str.to_re "0")) (re.opt (re.range "0" "1")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.* (str.to_re "0")) (re.union (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))))) (str.to_re "\u{0a}")))))
; MailerHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "MailerHost:User-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
