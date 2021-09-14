//includo le varie librerie 
#include<opencv2/opencv.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<iostream> //standard
#include<time.h> //per il get time
#include<string.h> //per convertire i numeri in stringa
#include<algorithm> //per utilizzare il sort
#include<math.h> //libreria con funzioni matematiche 

#define DEBUG 2
#define LOOP 0 

using namespace std;
using namespace cv;

struct rc { //struttura contenente i vettori delle righe e delle colonne
	vector<int> rg;
	vector<int> cl;
};

struct immagine { //struttura contentente l'immagine, i contorni, i contorni approssimati e i valori metrici
	vector<vector<Point>> contours;
	vector<vector<Point>> contours_poly;
	vector<Point2f> centers;
	Mat contourOutput;
	double metric[100];
};

struct elementi { //struttura contentente la posizione degli angoli, posizione centri, Valore massimi e minimi X/Y e corrispettivi Y/X
	vector<vector<Point>> Angoli;
	vector<Point2f> Centri;
	int Valori[4];
	int Valori2[4];
};

Mat imRotate(Mat source, double angle) { //Funzione per la rotazione dell'immagine 
	Mat dst;
	//Caso speciale in cui l'angolo sia 360°
	if (fmod(angle, 360.0) == 0.0) //funzione che ritorna il resto tra angle e 360.0
		dst = source;
	else {
		Point2f center(source.cols / 2.0F, source.rows / 2.0F); //calcolo il centro dell'immagine 
		Mat rot = getRotationMatrix2D(center, angle, 1.0); //Effettuo la rotazione rispetto al centro 
		//Determino il rettangolo esterno 
		Rect bbox = RotatedRect(center, source.size(), float(angle)).boundingRect();
		//Sistemo la matrice così da non tagliare nulla
		rot.at<double>(0, 2) += bbox.width / 2.0 - center.x;
		rot.at<double>(1, 2) += bbox.height / 2.0 - center.y;
		warpAffine(source, dst, rot, bbox.size(), INTER_LINEAR);
	}
	return dst; 
}

Mat im2bw(Mat image) { //Trovo i bordi dell'immagine con una soglia di 210 su 255
	Mat im = image.clone();
	threshold(image, im, 210, 255, THRESH_BINARY);
	return im;
}

Mat imfill(Mat image) { //riempie i bordi dell'immagine 
	//Mat fill = image.clone();
	Mat copia = image;
	for (int i = 0; i < copia.cols; i++) { //per ogni colonna
		if (copia.at<char>(0, i) == 0) {
			floodFill(copia, Point(i, 0), 255, 0, 10, 10);
		}
		if (copia.at<char>(copia.rows - 1, i) == 0) {
			floodFill(copia, Point(i, copia.rows - 1), 255, 0, 10, 10);
		}
	}
	copia = 255 - copia;
	return copia;
}

immagine trova_bordi(Mat src){ //funzione che restituisce una struttura contentente la posizione degli angoli e dei centri
	immagine ritorno;
	vector<vector<Point>> contorni;
	Mat uscita = src.clone();
	findContours(uscita, contorni, RETR_LIST, CHAIN_APPROX_NONE); //trova i contorni
	double b, c;
	double metrica[100];
	for (int i = 0; i < 100; i++) {//inizializzo l'array
		metrica[i] = 0; 
	}

	vector<vector<Point>> contourspoly(contorni.size());
	vector<Rect> boundRect(contorni.size());
	vector<Point2f>center(contorni.size());
	vector<float>radius(contorni.size());

	for (size_t i = 0; i < contorni.size(); i++) { //calcolo la metrica 
		b = contourArea(contorni[i]); //calcola l'area contenuta nel contorno
		c = arcLength(contorni[i], true); //calcola il perimetro del contorno 
		metrica[i] = (4 * 3, 14 * b) / (c * c); //metrica 4*pi*Area/perimetro^2
		approxPolyDP(contorni[i], contourspoly[i], 3, true); //fornisce la forma approssimata della curva
		minEnclosingCircle(contourspoly[i], center[i], radius[i]); //fornisce centro dell'oggetto e raggio
		if (DEBUG) {
			printf("%d: perimetro=%f, area =%f, metric=%f \n", int(i), c, b, metrica[i]);
		}
	}
	ritorno.centers = center;
	ritorno.contours_poly = contourspoly;
	ritorno.contourOutput = uscita;
	ritorno.contours = contorni;

	for (int i = 0; i < 100; i++) {
		ritorno.metric[i] = metrica[i];
	}
	return ritorno;
}

elementi trova_valori(immagine src) {//funzione che distingue quali sono i cerchi e gli angoli, e i valori X/Y Max e Min
	elementi ritorno;
	vector<vector<Point>> angoli; //salvo gli oggetti
	for (int i = 0; i < src.contours.size(); i++) {
		if ((src.metric[i] > 0.12 && src.metric[i] < 0.2) || (src.metric[i] > 0.21 && src.metric[i] < 0.27) || (src.metric[i] > 0.28 && src.metric[i] < 0.35)) {
			angoli.push_back(src.contours[i]); //salvo gli angoli
		}
	}

	int C[4];
	int C2[4]; //corrispettive
	C[0] = angoli[0][0].x;//-0: Cxmin
	C[1] = angoli[0][0].y;//-1: Cymin
	C[2] = angoli[0][0].x;//-2: Cxmax
	C[3] = angoli[0][0].y;//-3: Cymax
	C2[0] = angoli[0][0].y;//-0: Corrispettiva Cy a Cxmin
	C2[1] = angoli[0][0].x;//-1: Corrispettiva Cx a Cymin
	C2[2] = angoli[0][0].y;//-2: Corrispettiva Cy a Cxmax
	C2[3] = angoli[0][0].x;//-3: Corrispettiva Cx a Cymax

	for (int i = 0; i < angoli.size(); i++) { //determino il max, min e i corrispettivi 
		for (int j = 0; j < angoli[i].size(); j++) {
			if (C[0] > angoli[i][j].x) {
				C[0] = angoli[i][j].x;
				C2[0] = angoli[i][j].y;
			}
			if (C[1] > angoli[i][j].y) {
				C[1] = angoli[i][j].y;
				C2[1] = angoli[i][j].x;
			}
			if (C[2] < angoli[i][j].x) {
				C[2] = angoli[i][j].x;
				C2[2] = angoli[i][j].y;
			}
			if (C[3] < angoli[i][j].y) {
				C[3] = angoli[i][j].y;
				C2[3] = angoli[i][j].x;
			}
		}
	}

	vector<Point2f>centri; //salvo i cerchi
	for (int i = 0; i < src.contours.size(); i++) {
		if ((src.metric[i] > 0.69 && src.metric[i] < 1.5)) {
			centri.push_back(src.centers[i]);
		}
	}
	ritorno.Angoli = angoli;
	ritorno.Centri = centri;
	for (int i = 0; i < 4; i++) {
		ritorno.Valori[i] = C[i];
		ritorno.Valori2[i] = C2[i];
	}
	return ritorno;
}

rc righe_colonne(Mat src, elementi sorgente) { //funzione che determina il valore delle righe e colonne
	rc ritorno;

	int dist;
	if (src.rows <= src.cols) {
		dist = int(src.cols / 5.5);
	}
	else {
		dist = int(src.rows / 5.5);
	}

	vector<double>rg;
	vector<double>ct;
	for (int i = 0; i < sorgente.Centri.size(); i++) {
		rg.push_back(sorgente.Centri[i].y);
		ct.push_back(sorgente.Centri[i].x);
	}

	sort(rg.begin(), rg.end()); //ordino in maniera crescente
	sort(ct.begin(), ct.end());
	if (DEBUG) {
		printf("Stampa righe ordinate \n");
		for (int i = 0; i < sorgente.Centri.size(); i++) {
			printf("%f, ", rg[i]);
		}
		printf("\n");
		printf("Stampa colonne ordinate \n");
		for (int i = 0; i < sorgente.Centri.size(); i++) {
			printf("%f, ", ct[i]);
		}
		printf("\n");
	}

	vector<int> tmpr;
	vector<int> tmpc;
	int pr = 0, pc = 0;
	for (int i = 0; i < ct.size(); i++) {
		if (i == 0) {
			tmpr.push_back(int(rg[i]));
			tmpc.push_back(int(ct[i]));
		}
		else {
			if (int(ct[i]) > tmpc[pc] + 10) {
				tmpc.push_back(int(ct[i]));
				pc = pc + 1;
			}
			if (int(rg[i]) > tmpr[pr] + 10) {
				tmpr.push_back(int(rg[i]));
				pr = pr + 1;
			}
		}
	}
	if (DEBUG) {
		printf("Stampa righe ordinate \n");
		for (int i = 0; i < tmpr.size(); i++) {
			printf("%d, ", tmpr[i]);
		}
		printf("\n");
		printf("Stampa colonne ordinate \n");
		for (int i = 0; i < tmpc.size(); i++) {
			printf("%d, ", tmpc[i]);
		}
		printf("\n");
	}
	if (DEBUG) printf("distanza: %d\n", dist);

	vector<int>j;
	int p = 0;
	for (int i = 0; i < tmpr.size(); i++) {
		if (i == 0) {
			if (tmpr[i] > (dist + 10)) {
				j.push_back(dist);
				j.push_back(tmpr[i]);
				p = p + 2;
			}
			else {
				j.push_back(tmpr[i]);
				p = p + 1;
			}
		}
		else {
			if ((tmpr[i] - tmpr[int(i - 1)]) > (dist + 10)) {
				int t = int(tmpr[i] - tmpr[int(i - 1)]) / (dist + 10);
				for (int k = p; k < p + t; k++) {
					j.push_back(j[int(k - 1)] + dist);
				}
				p = p + t;
			}
			else {
				j.push_back(tmpr[i]);
				p = p + 1;
			}
		}
	}
	tmpr = j;
	if (src.rows - tmpr[tmpr.size() - 1] > dist + 10) {
		int t = int((src.rows - tmpr[tmpr.size()]) / dist);
		t = t - 1;
		for (int k = p; k < p + t; k++) {
			tmpr.push_back(tmpr[int(k - 1)] + dist);
		}
	}
	vector<int>l;
	p = 0;
	for (int i = 0; i < tmpc.size(); i++) {
		if (i == 0) {
			if (tmpc[i] > (dist + 10)) {
				l.push_back(dist);
				l.push_back(tmpc[i]);
				p = p + 2;
			}
			else {
				l.push_back(tmpc[i]);
				p = p + 1;
			}
		}
		else {
			if ((tmpc[i] - tmpc[int(i - 1)]) > (dist + 10)) {
				int t = int(tmpc[i] - tmpc[int(i - 1)]) / (dist + 10);
				for (int k = p; k < p + t; k++) {
					l.push_back(l[int(k - 1)] + dist);
				}
				p = p + t;
			}
			else {
				l.push_back(tmpc[i]);
				p = p + 1;
			}
		}
	}
	tmpc = l;
	if (src.cols - tmpc[tmpc.size() - 1] > dist + 10) {
		int t = int((src.cols - tmpc[tmpc.size()]) / dist);
		t = t - 1;
		for (int k = p; k < p + t; k++) {
			tmpc.push_back(tmpc[int(k - 1)] + dist);
		}
	}
	if (DEBUG) {
		printf("Stampa righe complete \n");
		for (int i = 0; i < tmpr.size(); i++) {
			printf("%d, ", tmpr[i]);
		}
		printf("\n");
		printf("Stampa colonne complete \n");
		for (int i = 0; i < tmpc.size(); i++) {
			printf("%d, ", tmpc[i]);
		}
		printf("\n");
	}
	//ritorno solo le colonne singolari, stessa cosa per le righe
	ritorno.cl = tmpc;
	ritorno.rg = tmpr;
	return ritorno;
}

int main() {
	clock_t start, end; //definisco il tempo
	double tempo;
	start = clock(); //inizio a contare
	//imread funzione per leggere l'immagine, questa può avere due parametri
	//-nome o path immagine
	//-numero intero che di default è 1, ma se si inserisce 0 allora la lettura avviene già in bianco e nero

	Mat img = imread("./Immagini/posizione6.bmp", 1); //carico l'immagine 
	if (img.data == NULL) { //se non riesce a leggere nulla
		printf("Errore nell'apertura dell'immagine \n");
		return -1;
	}
	if (DEBUG) printf("Dimensioni immagini: colonne=%d e righe=%d\n", img.cols, img.rows);

	if (DEBUG) {//stampo l'immagine
		namedWindow("Immagine Originale", WINDOW_AUTOSIZE);
		imshow("Immagine Originale", img);
		waitKey(0);
	}

	int max = 1;
	if (LOOP) {
		max = 30;
	}
	for (int k = 0; k < max; k++) {//controllo se voglio un loop (fase test)
		//converto l'immagine in scala di grigi 
		Mat imgGray = img.clone();
		cvtColor(img, imgGray, COLOR_BGR2GRAY); //scala di grigi 
		GaussianBlur(imgGray, imgGray, Size(3, 3), 0, 0, BORDER_DEFAULT); //Filtro gaussiano per la sfocatura
		if (DEBUG) {
			imshow("Immagine Grigio", imgGray);
			waitKey(0);
		}

		imgGray = 255 - imgGray; //negativo 
		/*if (DEBUG) {
			imshow("Immagine Negativo", imgGray);
			waitKey(0);
		}*/

		imgGray = im2bw(imgGray); //torno l'immagine con 255 nei valori sopra il 210
		/*if (DEBUG) {
			imshow("Immagine Campionata", imgGray);
			waitKey(0);
		}*/

		Canny(imgGray, imgGray, 50, 200, 3, false); //applico filtro di Canny

		if (DEBUG) {
			imshow("Immagine Canny", imgGray);
			waitKey(0);
		}

		imgGray = imfill(imgGray); //riempio i buchi
		/*if (DEBUG) {
			imshow("Immagine Riempita", imgGray);
			waitKey(0);
		}*/

		int erosione_size = 3; //erodo l'immagine per eliminare le imperfezioni
		Mat element = getStructuringElement(MORPH_ELLIPSE, Size(2 * erosione_size + 1, 2 * erosione_size + 1), Point(erosione_size, erosione_size));
		erode(imgGray, imgGray, element);
		/*if (DEBUG) {
			imshow("Immagine Erosa", imgGray);
			waitKey(0);
		}*/

		int dilation_size = 3; //dilato l'immagine ripulita
		element = getStructuringElement(MORPH_ELLIPSE, Size(2 * dilation_size + 1, 2 * dilation_size + 1), Point(dilation_size, dilation_size));
		dilate(imgGray, imgGray, element);
		if (DEBUG) {
			imshow("Immagine Dilatata", imgGray);
			waitKey(0);
		}
		immagine iniziale = trova_bordi(imgGray);
		Mat drawing = Mat::zeros(imgGray.size(), CV_8UC3);
		if (DEBUG > 1) {
			for (size_t i = 0; i < iniziale.contours.size(); i++) {
				Scalar color = Scalar(150, 150, 150);
				drawContours(drawing, iniziale.contours_poly, (int)i, color);
				circle(drawing, iniziale.centers[i], 3, color, 2);
				putText(drawing, to_string(iniziale.metric[i]), iniziale.centers[i], FONT_HERSHEY_SIMPLEX, 0.4, Scalar(0, 143, 143), 2);
			}
			imshow("Contours", drawing);
			waitKey(0);
		}
		elementi primo = trova_valori(iniziale);
		
		double y = abs(primo.Valori[1] - primo.Valori2[0]);
		double x = abs(primo.Valori[2] - primo.Valori[0]);

		double angle = atan2(y, x);
		double degree = angle * 180 / CV_PI;
		if (degree < 5.0) {
			degree = 0.0;
		}
		if (DEBUG) {
			printf("y=%f, x=%f \n", y, x);
			printf("Angolo = %f\n", degree);
		}

		Mat rotate = imRotate(iniziale.contourOutput, -degree);
		iniziale = trova_bordi(rotate);

		elementi secondo = trova_valori(iniziale);

		Rect myR(secondo.Valori[0], secondo.Valori[1], secondo.Valori[2] - secondo.Valori[0], secondo.Valori[3] - secondo.Valori[1]);
		Mat imgCroped = rotate(myR);
		if (DEBUG) {
			namedWindow("Immagine ritagliata", WINDOW_AUTOSIZE);
			imshow("Immagine ritagliata", imgCroped);
			waitKey(0);
		}

		immagine finale = trova_bordi(imgCroped);

		/*if (DEBUG > 1) {
			Mat cnt2(imgCroped.size(), CV_8UC3, Scalar(0, 0, 0));
			Scalar colors2[3];
			colors2[0] = cv::Scalar(255, 0, 0);
			colors2[1] = cv::Scalar(0, 255, 0);
			colors2[2] = cv::Scalar(0, 0, 255);
			for (size_t idx = 0; idx < contours2.size(); idx++) {
				drawContours(cnt2, contours2, idx, colors2[idx % 3]);
			}
			imshow("Immagine Contorni", cnt2);
			waitKey(0);
		}
		for (int i = 0; i < sizeof(metric) / sizeof(metric[0]); i++) {
			metric[i] = 0;
		}
		for (size_t i = 0; i < contours2.size(); i++) {
			b = contourArea(contours2[i]);
			c = arcLength(contours2[i], true);
			metric[i] = (4 * 3, 14 * b) / (c * c);
			approxPolyDP(contours2[i], contours_poly[i], 3, true); //fornisce la forma approssimata della curva
			minEnclosingCircle(contours_poly[i], centers[i], radius[i]); //fornisce centro dell'oggetto e raggio
			if (DEBUG) {
				printf("%d: perimetro=%f, area =%f, metric=%f \n", int(i), c, b, metric[i]);
			}
		}*/

		drawing = Mat::zeros(imgCroped.size(), CV_8UC3);
		/*if (DEBUG > 1) {
			for (size_t i = 0; i < finale.contours.size(); i++) {
				Scalar color = Scalar(150, 150, 150);
				drawContours(drawing, finale.contours_poly, (int)i, color);
				circle(drawing, finale.centers[i], 3, color, 2);
				putText(drawing, to_string(finale.metric[i]), finale.centers[i], FONT_HERSHEY_SIMPLEX, 0.4, Scalar(0, 143, 143), 2);
			}
			imshow("Contours", drawing);
			waitKey(0);
		}*/
		elementi terzo = trova_valori(finale);
		if (DEBUG > 1) {
			drawing = Mat::zeros(imgCroped.size(), CV_8UC3);
			for (size_t i = 0; i < finale.contours.size(); i++) {
				drawContours(drawing, finale.contours_poly, (int)i, Scalar(255, 255, 255));
			}
			for (size_t i = 0; i < terzo.Centri.size(); i++) {
				Scalar color = Scalar(150, 0, 0);
				circle(drawing, terzo.Centri[i], 3, color, 2);
			}
			imshow("Stampo solo i cerchi", drawing);
			waitKey(0);
		}
		

		rc valori = righe_colonne(imgCroped, terzo);

		vector <vector<int>> A(valori.rg.size());
		for (int i = 0; i < valori.rg.size(); i++) {
			A[i] = vector<int>(valori.cl.size());
		}

		for (int i = 0; i < valori.rg.size(); i++) {
			for (int k = 0; k < valori.cl.size(); k++) {
				A[i][k] = 0;
			}
		}

		int tr2 = 0, tc2 = 0;
		int n = 1;
		for (int i = 0; i < terzo.Centri.size(); i++) {
			tr2 = tc2 = 0;
			for (int k = 0; k < valori.rg.size() && n; k++) {
				double tmp1 = double(valori.rg[k] - 10);
				double tmp2 = double(valori.rg[k] + 10);
				if (tmp1 <= terzo.Centri[i].y && terzo.Centri[i].y <= tmp2) {
					tr2 = k;
					n = 0;
				}
			}
			n = 1;
			for (int k = 0; k < valori.cl.size() && n; k++) {
				double tmp1 = double(valori.cl[k] - 10);
				double tmp2 = double(valori.cl[k] + 10);
				if (tmp1 <= terzo.Centri[i].x && terzo.Centri[i].x <= tmp2) {
					tc2 = k;
					n = 0;
				}
			}
			if (DEBUG) printf("%d e %d \n", tr2, tc2);
			A[tr2][tc2] = 1;
			n = 1;
		}

		if (DEBUG) {
			printf("\nSTAMPA MATRICE CODIFICATE \n");

			for (int i = 0; i < valori.rg.size(); i++) {
				for (int k = 0; k < valori.cl.size(); k++) {
					printf("\t %d", A[i][k]);
				}
				printf("\n");
			}
		}
	}
	end = clock();
	tempo = ((double)(end - start)) / CLOCKS_PER_SEC;
	printf("\nIl tempo di esecuzione è di circa: %f secondi\n", tempo);
	return 0;
}

