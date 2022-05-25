import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './modules/user/user.module';

@Module({
  imports: [
    MongooseModule.forRoot(
      'mongodb+srv://admin:medzy@medzy.fy90w.mongodb.net/Medzy_Pharmacy?retryWrites=true&w=majority',
    ),
    UserModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
