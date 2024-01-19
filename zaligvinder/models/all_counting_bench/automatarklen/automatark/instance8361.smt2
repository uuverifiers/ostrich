(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[0-9]+\.d{3}? *$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (str.to_re "d")) (re.* (str.to_re " ")) (str.to_re "/\u{0a}"))))
; seqepagqfphv\u{2f}sfdX-Mailer\x3A
(assert (not (str.in_re X (str.to_re "seqepagqfphv/sfdX-Mailer:\u{13}\u{0a}"))))
; [0-9.\-/+() ]{4,}
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))) (re.* (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " ")))))))
; /filename=[^\n]*\u{2e}jpf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpf/i\u{0a}")))))
; /setup=[a-z]\&s=\d\&r=\d{5}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/setup=") (re.range "a" "z") (str.to_re "&s=") (re.range "0" "9") (str.to_re "&r=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
