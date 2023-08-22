(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xm/i\u{0a}")))))
; ^[-|\+]?[0-9]{1,3}(\,[0-9]{3})*$|^[-|\+]?[0-9]+$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+"))) ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "|") (str.to_re "+"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^[A-Z0-9<]{9}[0-9]{1}[A-Z]{3}[0-9]{7}[A-Z]{1}[0-9]{7}[A-Z0-9<]{14}[0-9]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 9 9) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "<"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 14 14) (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "<"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; IPAnaloffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "IPAnaloffers.bullseye-network.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
