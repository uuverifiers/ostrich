(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z0-9]{5})$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}dir/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dir/i\u{0a}"))))
; ^([0-7]{3})$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "7")) (str.to_re "\u{0a}"))))
; Guarded\s+3A\s+data2\.activshopper\.comUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Guarded") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "3A") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "data2.activshopper.comUser-Agent:\u{0a}"))))
; AgentHWAEUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "AgentHWAEUser-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
