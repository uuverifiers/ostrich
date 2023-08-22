(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (((\d{0,2})\(\d{3}\))|(\d{3}-))\d{3}-\d{4}\s{0,}((([Ee][xX][Tt])|([Pp][Oo][Ss][Tt][Ee])):\d{1,5}){0,1}
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.union (re.++ (re.union (str.to_re "E") (str.to_re "e")) (re.union (str.to_re "x") (str.to_re "X")) (re.union (str.to_re "T") (str.to_re "t"))) (re.++ (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "O") (str.to_re "o")) (re.union (str.to_re "S") (str.to_re "s")) (re.union (str.to_re "T") (str.to_re "t")) (re.union (str.to_re "E") (str.to_re "e")))) (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; is\s+lnzzlnbk\u{2f}pkrm\.fin\s+Host\x3A\x2Ftoolbar\x2Fsupremetb
(assert (not (str.in_re X (re.++ (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:/toolbar/supremetb\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
