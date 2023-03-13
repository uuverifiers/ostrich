(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}cpe/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cpe/i\u{0a}"))))
; (^\d{1,2}\.\d{1,2}\.\d{4})|(^\d{1,2}\.\d{1,2})|(^\d{1,2})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; snprtz\x7Cdialno\s+3Awww\u{2e}urlblaze\u{2e}netulmxct\u{2f}mqoyc
(assert (not (str.in_re X (re.++ (str.to_re "snprtz|dialno") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "3Awww.urlblaze.netulmxct/mqoyc\u{0a}")))))
(check-sat)
