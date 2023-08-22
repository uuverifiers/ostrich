(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; asdbiz\x2Ebiz\dATTENTION\x3Aemail
(assert (str.in_re X (re.++ (str.to_re "asdbiz.biz") (re.range "0" "9") (str.to_re "ATTENTION:email\u{0a}"))))
; (t|T)(o|O)\s\d{4}($|\D)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "t") (str.to_re "T")) (re.union (str.to_re "o") (str.to_re "O")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (re.comp (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Referer\x3A\s+www\u{2e}proventactics\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.proventactics.com\u{0a}"))))
; /filename=[^\n]*\u{2e}pfa/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfa/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
