(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A3AHelpAgent\x3AHost\x3AsearchresltHost\x3Anotification
(assert (str.in_re X (str.to_re "User-Agent:3AHelpAgent:Host:searchresltHost:notification\u{13}\u{0a}")))
; /filename=[^\n]*\u{2e}sln/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sln/i\u{0a}"))))
; ^([A-Z]{2}\s?(\d{2})?(-)?([A-Z]{1}|\d{1})?([A-Z]{1}|\d{1})?( )?(\d{4}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (str.to_re "-")) (re.opt (re.union ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.opt (re.union ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.opt (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")))))
; /\u{2f}[\w\u{2d}]*\u{2e}\u{2e}$/mU
(assert (str.in_re X (re.++ (str.to_re "//") (re.* (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "../mU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
