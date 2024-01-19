(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; s_sq=aolsnssigninUser-Agent\x3A
(assert (str.in_re X (str.to_re "s_sq=aolsnssigninUser-Agent:\u{0a}")))
; ProxyDownCurrentUser-Agent\x3AHost\x3Acom\x2Findex\.php\?tpid=
(assert (not (str.in_re X (str.to_re "ProxyDownCurrentUser-Agent:Host:com/index.php?tpid=\u{0a}"))))
; /filename=[^\n]*\u{2e}rat/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rat/i\u{0a}"))))
; to\d+User-Agent\x3AFiltered
(assert (not (str.in_re X (re.++ (str.to_re "to") (re.+ (re.range "0" "9")) (str.to_re "User-Agent:Filtered\u{0a}")))))
; [0][^0]|([^0]{1}(.){1})|[^0]*
(assert (str.in_re X (re.union (re.++ (str.to_re "0") (re.comp (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.comp (str.to_re "0"))) ((_ re.loop 1 1) re.allchar)) (re.++ (re.* (re.comp (str.to_re "0"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
