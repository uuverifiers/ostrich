(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Spy\-Locked\s+ExploiterSchwindler\x2Fr\x2Fkeys\x2Fkeys
(assert (str.in_re X (re.++ (str.to_re "Spy-Locked") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ExploiterSchwindler/r/keys/keys\u{0a}"))))
; /filename=[^\n]*\u{2e}bak/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".bak/i\u{0a}"))))
; YWRtaW46cGFzc3dvcmQ\s+www\x2Ealfacleaner\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "YWRtaW46cGFzc3dvcmQ") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.alfacleaner.com\u{0a}"))))
; 3[47]\d{13}
(assert (str.in_re X (re.++ (str.to_re "3") (re.union (str.to_re "4") (str.to_re "7")) ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\x3Aetbuviaebe\u{2f}eqv\.bvv
(assert (not (str.in_re X (str.to_re "User-Agent:etbuviaebe/eqv.bvv\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
