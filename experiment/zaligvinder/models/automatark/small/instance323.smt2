(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AHost\x3AFrom\u{3a}\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furaxbnymomspyo\u{2f}zowy
(assert (str.in_re X (str.to_re "Host:Host:From:\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furaxbnymomspyo/zowy\u{0a}")))
; ^\D{0,2}[0]{0,3}[1]{0,1}\D{0,2}([2-9])(\d{2})\D{0,2}(\d{3})\D{0,2}(\d{3})\D{0,2}(\d{1})\D{0,2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 0 3) (str.to_re "0")) (re.opt (str.to_re "1")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 0 2) (re.comp (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Filtered\s+Yeah\!\d+HXDownloadasdbiz\x2EbizUser-Agent\x3Awww\x2Eezula\x2EcomUser-Agent\u{3a}etbuviaebe\u{2f}eqv\.bvv
(assert (str.in_re X (re.++ (str.to_re "Filtered") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Yeah!") (re.+ (re.range "0" "9")) (str.to_re "HXDownloadasdbiz.bizUser-Agent:www.ezula.comUser-Agent:etbuviaebe/eqv.bvv\u{0a}"))))
(check-sat)
