(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z_]{1}[a-zA-Z0-9_]+$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; Pass-OnthecontainsUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "Pass-OnthecontainsUser-Agent:\u{0a}"))))
; ((FI|HU|LU|MT|SI)-?)?[0-9]{8}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "FI") (str.to_re "HU") (str.to_re "LU") (str.to_re "MT") (str.to_re "SI")) (re.opt (str.to_re "-")))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}qcp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".qcp/i\u{0a}"))))
; Toolbar\d+Host\x3A\d+4\u{2e}8\u{2e}4\x7D\x7BTrojan\x3Aare
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "4.8.4}{Trojan:are\u{0a}"))))
(check-sat)
