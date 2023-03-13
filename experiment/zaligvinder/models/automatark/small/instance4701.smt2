(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}oga/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".oga/i\u{0a}")))))
; /^dataget\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/dataget|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; media\x2Edxcdirect\x2Ecom
(assert (not (str.in_re X (str.to_re "media.dxcdirect.com\u{0a}"))))
; Netspy\s\x3Aauto\x2Eisearch\x2EcomUser-Agent\x3Aaohobygi\u{2f}zwiwHWAEfhfksjzsfu\u{2f}ahm\.uqs
(assert (str.in_re X (re.++ (str.to_re "Netspy") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re ":auto.isearch.comUser-Agent:aohobygi/zwiwHWAEfhfksjzsfu/ahm.uqs\u{0a}"))))
(check-sat)
