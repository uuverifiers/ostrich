(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{23}\d{2}\u{3a}\d{2}\u{3a}\d\d$/R
(assert (not (str.in_re X (re.++ (str.to_re "/#") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ":") (re.range "0" "9") (re.range "0" "9") (str.to_re "/R\u{0a}")))))
; /("(\\["\\]|[^"])*("|$)|\S)+/g
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "/g\u{0a}"))))
; \u{22}reaction\x2Etxt\u{22}\d+sErverdist\x2Eatlas\x2Dia\x2EcomUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "\u{22}reaction.txt\u{22}") (re.+ (re.range "0" "9")) (str.to_re "sErverdist.atlas-ia.comUser-Agent:\u{0a}"))))
; /^\/\?[a-f0-9]{32}$/U
(assert (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; /filename=[^\n]*\u{2e}crx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".crx/i\u{0a}")))))
(check-sat)
