(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}Type\u{2f}XRef\u{2f}W\u{5b}[^\u{5d}]*?\d{7,15}/smi
(assert (str.in_re X (re.++ (str.to_re "//Type/XRef/W[") (re.* (re.comp (str.to_re "]"))) ((_ re.loop 7 15) (re.range "0" "9")) (str.to_re "/smi\u{0a}"))))
; thesearchresltLoggerHost\x3ABetaHWAEHost\x3Ais
(assert (not (str.in_re X (str.to_re "thesearchresltLoggerHost:BetaHWAEHost:is\u{0a}"))))
; Subject\x3A\s+Host\x3A.*www\x2Ealfacleaner\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* re.allchar) (str.to_re "www.alfacleaner.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
