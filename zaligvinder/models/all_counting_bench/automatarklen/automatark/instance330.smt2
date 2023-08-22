(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eeblocs\x2Ecomcorep\x2Edmcast\x2Ecom
(assert (str.in_re X (str.to_re "www.eblocs.com\u{1b}corep.dmcast.com\u{0a}")))
; Host\x3A\s+\.ico\s+Host\x3Aorigin\x3Dsidefind
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".ico") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:origin=sidefind\u{0a}")))))
; /^User-Agent\x3A[^\r\n]*malware/miH
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "malware/miH\u{0a}")))))
; /^Host\u{3a}[^\u{0d}\u{0a}]+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\u{3a}\d{1,5}\u{0d}?$/mi
(assert (str.in_re X (re.++ (str.to_re "/Host:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")) (re.opt (str.to_re "\u{0d}")) (str.to_re "/mi\u{0a}"))))
; User-Agent\x3A\w+\u{0d}\u{0a}subject=GhostVoice
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0d}\u{0a}subject=GhostVoice\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
