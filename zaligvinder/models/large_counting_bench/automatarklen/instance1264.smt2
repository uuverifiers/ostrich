(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}bcl/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".bcl/i\u{0a}")))))
; snprtz\x7Cdialno\s+3Awww\u{2e}urlblaze\u{2e}netulmxct\u{2f}mqoyc
(assert (not (str.in_re X (re.++ (str.to_re "snprtz|dialno") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "3Awww.urlblaze.netulmxct/mqoyc\u{0a}")))))
; /\u{2e}wk4([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.wk4") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B(\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B){500}/m
(assert (not (str.in_re X (re.++ (str.to_re "/\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={") ((_ re.loop 500 500) (str.to_re "\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={")) (str.to_re "/m\u{0a}")))))
; /filename=[^\n]*\u{2e}wmf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wmf/i\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
