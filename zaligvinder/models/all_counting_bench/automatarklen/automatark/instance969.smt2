(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; hg diff --nodates | egrep -e "---" -v | egrep -e "^-" -c
(assert (str.in_re X (re.union (str.to_re "hg diff --nodates ") (str.to_re " egrep -e \u{22}---\u{22} -v ") (str.to_re " egrep -e \u{22}-\u{22} -c\u{0a}"))))
; /filename=[^\n]*\u{2e}spx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".spx/i\u{0a}")))))
; ^(([1-9]\d{0,2}(\,\d{3})*|([1-9]\d*))(\.\d{2})?)|([0]\.(([0][1-9])|([1-9]\d)))$
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "\u{0a}0.") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))))))))
; Referer\x3A.*notification.*qisezhin\u{2f}iqor\.ymspasServer\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Referer:") (re.* re.allchar) (str.to_re "notification\u{13}") (re.* re.allchar) (str.to_re "qisezhin/iqor.ym\u{13}spasServer:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
