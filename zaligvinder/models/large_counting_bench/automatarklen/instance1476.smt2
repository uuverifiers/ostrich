(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (str.in_re X (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}")))
; tipHost\x3AGirafaClient\u{0d}\u{0a}subject=GhostVoice
(assert (str.in_re X (str.to_re "tipHost:GirafaClient\u{13}\u{0d}\u{0a}subject=GhostVoice\u{0a}")))
; ^(\d{5}-\d{2}-\d{7})*$
(assert (not (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /^\/\u{3f}[1-9][A-Za-z0-9~_-]{240}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//?") (re.range "1" "9") ((_ re.loop 240 240) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "~") (str.to_re "_") (str.to_re "-"))) (str.to_re "/Ui\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
