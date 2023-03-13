(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]{2}?(\d{7}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9"))))))
; /filename=[^\n]*\u{2e}paq8o/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".paq8o/i\u{0a}"))))
; /filename=[^\n]*\u{2e}flac/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flac/i\u{0a}")))))
; [+]?[ ]?\d{1,3}[ ]?\d{1,3}[- ]?\d{4}[- ]?\d{4}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re " ")) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Filtered\s+Yeah\!\d+HXDownloadasdbiz\x2EbizUser-Agent\x3Awww\x2Eezula\x2EcomUser-Agent\u{3a}etbuviaebe\u{2f}eqv\.bvv
(assert (str.in_re X (re.++ (str.to_re "Filtered") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Yeah!") (re.+ (re.range "0" "9")) (str.to_re "HXDownloadasdbiz.bizUser-Agent:www.ezula.comUser-Agent:etbuviaebe/eqv.bvv\u{0a}"))))
(check-sat)
